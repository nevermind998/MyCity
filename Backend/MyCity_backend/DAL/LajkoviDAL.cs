using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL
{
    public class LajkoviDAL : ILajkoviDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IObavestenjaDAL _IObavestenjaDAL;
        public LajkoviDAL(ApplicationDbContext context, IObavestenjaDAL IObavestenjaDAL)
        {
            _context = context;
            _IObavestenjaDAL = IObavestenjaDAL;
        }

        public void deleteLajk(List<Lajkovi> lajk)
        {
            if (lajk != null)
            {
                _context.lajkovi.RemoveRange(lajk);
                _context.SaveChanges();
            }
        }

        public List<Lajkovi> getAllLajkovi()
        {
            return _context.lajkovi.Include(l => l.korisnik).Include(l=>l.objave).ToList();
        }
        public void saveLajk(Lajkovi data)
        {
            //idKorinika, idObjave => data
            var check = _context.lajkovi.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
            if (check != null )  //unlike
            {
                _IObavestenjaDAL.removeLajk(check);
                _context.lajkovi.Remove(check);
              
            }
            else //like
              {
                //provera da nije dislajkovao ili reportovao
                var checkDislajk = _context.dislajkovi.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkDislajk != null)
                {
                    _context.dislajkovi.Remove(checkDislajk);
                }
                var checkReport = _context.report.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkReport != null)
                {
                    _context.report.Remove(checkReport);
                }
                //like
                Lajkovi lajk = data;
                var id = _context.lajkovi.Count();
                if (id == 0)
                {
                    lajk.id = 1;
                }
                else
                {
                    lajk.id = _context.lajkovi.Max(o => o.id) + 1;
                }
                _context.lajkovi.Add(lajk);
                _IObavestenjaDAL.dodajLajk(lajk);
               }

            _context.SaveChanges();
        }

    }
}
