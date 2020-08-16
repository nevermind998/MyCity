using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Data;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL
{
    public class DislajkoviKomentaraDAL : IDislajkoviKomentaraDAL
    {
        private readonly ApplicationDbContext _context;

        public DislajkoviKomentaraDAL(ApplicationDbContext context)
        {
            _context = context;
        }

        public void deleteDislajkKomentara(List<DislajkoviKomentari> dislajkovi)
        {
            if (dislajkovi != null)
            {
                _context.dislajkoviKomentari.RemoveRange(dislajkovi);
                _context.SaveChanges();
            }
        }

        public List<DislajkoviKomentari> getAllDislajkovi()
        {
            return _context.dislajkoviKomentari.ToList();
        }

        public void saveDislajk(DislajkoviKomentari data)
        {
     
            var check = _context.dislajkoviKomentari.FirstOrDefault(d => d.KorisnikID == data.KorisnikID && d.KomentarID == data.KomentarID);
            if (check != null)  //undislike
            {
                _context.dislajkoviKomentari.Remove(check);
            }
            else //dislike
            {
                var checkLajk = _context.lajkoviKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkLajk != null)
                {
                    _context.lajkoviKomentari.Remove(checkLajk);
                }
                var checkReport = _context.reportKomentari.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.KomentarID == data.KomentarID);
                if (checkReport != null)
                {
                    _context.reportKomentari.Remove(checkReport);
                }
                DislajkoviKomentari dislajk = data;
                var id = _context.dislajkoviKomentari.Count();
                if (id == 0)
                {
                    dislajk.id = _context.dislajkoviKomentari.Count() + 1;
                }
                else
                {
                    dislajk.id = _context.dislajkoviKomentari.Max(o => o.id) + 1;
                }
                _context.dislajkoviKomentari.Add(dislajk);
            }

            _context.SaveChanges();
        }

        public int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            var check = _context.dislajkoviKomentari.FirstOrDefault(l => l.KomentarID == idKomentara && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }
    }
}
