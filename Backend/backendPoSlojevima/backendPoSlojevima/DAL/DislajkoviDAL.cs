using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Data;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL
{
    public class DislajkoviDAL : IDislajkoviDAL
    {
        private readonly ApplicationDbContext _context;

        public DislajkoviDAL (ApplicationDbContext context)
        {
            _context = context;
        }

        public void deleteDislajk(List<Dislajkovi> dislajk)
        {
            if (dislajk != null)
            {
                _context.dislajkovi.RemoveRange(dislajk);
                _context.SaveChanges();
            }
        }

        public List<Dislajkovi> getAllDislajkovi()
        {
            return _context.dislajkovi.ToList();
        }

        public void saveDislajk(Dislajkovi data)
        {
            //idKorinika, idObjave => data
            var check = _context.dislajkovi.FirstOrDefault(d => d.KorisnikID == data.KorisnikID && d.ObjaveID == data.ObjaveID);
            if (check != null)  //undislike
            {
                _context.dislajkovi.Remove(check);
            }
            else //dislike
            {
                //provera da nije dislajkovao ili reportovao
                var checkLajk = _context.lajkovi.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkLajk != null)
                {
                    _context.lajkovi.Remove(checkLajk);
                }
                var checkReport = _context.report.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkReport != null)
                {
                    return;
                   // _context.report.Remove(checkReport);
                }
                Dislajkovi dislajk = data;
               /* var id = _context.dislajkovi.Count();
                if (id == 0)
                {
                    dislajk.id = _context.dislajkovi.Count() + 1;
                }
                else
                {
                    dislajk.id = _context.dislajkovi.Max(o => o.id) + 1;
                }*/
                _context.dislajkovi.Add(dislajk);
            }

            _context.SaveChanges();
        }
    }
}
