using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL
{
    public class LajkoviKomentaraDAL : ILajkoviKomentaraDAL
    {
        private readonly ApplicationDbContext _context;

        public LajkoviKomentaraDAL(ApplicationDbContext context)
        {
            _context = context;
        }
        public List<LajkoviKomentara> getAllLajkovi()
        {
            return _context.lajkoviKomentari.ToList();
        }
        public void deleteLajkoveKomentara(List<LajkoviKomentara> lajkovi)
        {
            if (lajkovi != null)
            {
                _context.lajkoviKomentari.RemoveRange(lajkovi);
                _context.SaveChanges();
            }
        }

        public void saveLajk(LajkoviKomentara data)
        {
                var  check = _context.lajkoviKomentari.SingleOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (check != null)  //unlike
                {
                    _context.lajkoviKomentari.Remove(check);
                }
                else //like
                {
                var checkDislajk = _context.dislajkoviKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkDislajk != null)
                {
                    _context.dislajkoviKomentari.Remove(checkDislajk);
                }
                var checkReport = _context.reportKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkReport != null)
                {
                    _context.reportKomentari.Remove(checkReport);
                }
                LajkoviKomentara lajk = data;
                    var id = _context.lajkoviKomentari.Count();
                    if (id == 0)
                    {
                        lajk.id = _context.lajkoviKomentari.Count() + 1;
                    }
                    else
                    {
                        lajk.id = _context.lajkoviKomentari.Max(o => o.id) + 1;
                    }
                    _context.lajkoviKomentari.Add(lajk);
                }

                _context.SaveChanges();

            
        }

        public int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            var check = _context.lajkoviKomentari.FirstOrDefault(l => l.KomentarID == idKomentara && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }
    }
}
